export BatchExplorer

"""
    BatchExplorer(explorer::AbstractExplorer)
    BatchExplorer(explorers::AbstractExplorer...)
"""
struct BatchExplorer{E} <: AbstractExplorer
    explorer::E
end

BatchExplorer(explorers::AbstractExplorer...) = BatchExplorer(explorers)

(x::BatchExplorer)(values::AbstractMatrix) = [x.explorer(v) for v in eachcol(values)]
(x::BatchExplorer{<:Tuple})(values::AbstractMatrix) =
    [explorer(v) for (explorer, v) in zip(x.explorer, eachcol(values))]
