module BiMaps

# INFO: Why not using `Bijections.jl`?
# Because I want something simple and and want to use immutable dictionaries.
# The concept is similar to https://github.com/rikhuijzer/BidirectionalMaps.jl
# which, however, has been archived on GitHub.
# The author points to `CategoricalArrays.jl` or to `Bijections.jl`.
# Again, `Bijections.jl` might be nice but uses normal dictionaries, and I don't like the syntax.

import Base.ImmutableDict

export BiMap
export getleft, getright
export typeleft, typeright

# NOTE: not exporting `left` and `right` to not create confusion.
# Must use `BiMaps.left` or `BiMaps.right`
#export left, right

"""
    struct BiMap end

Bidirectional map where left elements are linked to the right ones and vice
versa.
"""
struct BiMap{S,T}
    # dictionary with left to right pairs
    left::ImmutableDict{S,T}

    # dictionary with right to left pairs
    right::ImmutableDict{T,S}

    function BiMap{S,T}(u, v) where {S,T}
        if length(u) != length(v)
            throw(ArgumentError("Bimap arraysshould be of the same length"))
        end

        makepairs(X, Y) = map(x -> first(x) => last(x), zip(X, Y))
        left = ImmutableDict(makepairs(u, v)...)
        right = ImmutableDict(makepairs(v, u)...)
        new(left, right)
    end

end

BiMap(x, y) = BiMap{eltype(x),eltype(y)}(x, y)

"""
    BiMap(dictionary)

Create a bimap starting from a dictionary.
Will fail if the values of the dictionary are not unique.
"""
BiMap(x::AbstractDict) = BiMap(keys(x), values(x))

# TODO: left and right do not really make sense. How about `getforward` or
# `getbackwards`? The basic idea is that we have a relationship `a <=> b` so
# we can get `b` from the index `a` (`getleft`) or `a` from the index `b`
# (`getright`), however also in this case the notation is quite confusing
# (left and right indicates the key, not the value)

"""
    getleft(bimap, key, fallback)

Return the right value stored for the given left key, or the given default value
if no mapping for the key is present.
"""
getleft(m::BiMap, key, default) = get(m.left, key, default)

"""
    getright(bimap, key, fallback)

Return the left value stored for the given right key, or the given default value
if no mapping for the key is present.
"""
getright(m::BiMap, key, default) = get(m.right, key, default)

"""
    typeleft(bimap)

Type of the left elements of the given bimap.
"""
typeleft(::BiMap{S,T}) where {S,T} = S

"""
    typeright(bimap)

Type of the right elements of the given bimap.
"""
typeright(::BiMap{S,T}) where {S,T} = T

"""
    left(bimap)

Access the left elements of the given bimap.
"""
left(m::BiMap) = m.left

"""
    right(bimap)

Access the right elements of the given bimap.
"""
right(m::BiMap) = m.right

end # module BiMaps
