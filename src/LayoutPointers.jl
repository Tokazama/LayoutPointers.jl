module LayoutPointers

using ArrayInterface, Static, LinearAlgebra
using ArrayInterface: CPUPointer, StrideIndex, offsets
using SIMDTypes: Bit, FloatingTypes
using Static: Zero, One
using ArrayInterface: contiguous_axis, contiguous_axis_indicator, contiguous_batch_size,
  stride_rank, offsets, offset1, CPUTuple, static_first, static_step, strides
using ManualMemory: preserve_buffer, offsetsize

export stridedpointer


@inline _map(f::F, x::Tuple{}) where {F} = ()
@inline _map(f::F, x::Tuple{X1}) where {F,X1} = (f(getfield(x,1,false)), )
@inline _map(f::F, x::Tuple{X1,X2,Vararg{Any,K}}) where {F,X1,X2,K} = (f(getfield(x,1,false)), _map(f, Base.tail(x))...)

@inline _map(f::F, x::Tuple{}, y::Tuple{}) where {F} = ()
@inline _map(f::F, x::Tuple{X1}, y::Tuple{Y1}) where {F,X1,Y1} = (f(getfield(x,1,false), getfield(y,1,false)), )
@inline _map(f::F, x::Tuple{X1,X2,Vararg{Any,K}}, y::Tuple{Y1,Y2,Vararg{Any,K}}) where {F,X1,X2,Y1,Y2,K} = (f(getfield(x,1,false), getfield(y,1,false)), _map(f, Base.tail(x), Base.tail(y))...)


"""
  abstract type AbstractStridedPointer{T,N,C,B,R,X<:Tuple{Vararg{Integer,N}},O<:Tuple{Vararg{Integer,N}}} end

T: element type
N: dimensionality
C: contiguous dim
B: batch size
R: rank of strides
X: strides
O: offsets
"""
abstract type AbstractStridedPointer{T,N,C,B,R,X<:Tuple{Vararg{Integer,N}},O<:Tuple{Vararg{Integer,N}}} end


include("stridedpointers.jl")
include("grouped_strided_pointers.jl")
include("precompile.jl")

end
