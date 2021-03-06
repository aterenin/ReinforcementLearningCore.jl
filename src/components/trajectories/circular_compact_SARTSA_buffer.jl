export CircularCompactSARTSATrajectory

const CircularCompactSARTSATrajectory = Trajectory{
    SARTSA,
    T1,
    NamedTuple{RTSA,T2},
} where {T1,T2<:Tuple{Vararg{<:CircularArrayBuffer}}}

"""
    CircularCompactSARTSATrajectory(;kwargs...)

Similar to [`VectorialCompactSARTSATrajectory`](@ref),
instead of using `Vector`s as containers, [`CircularArrayBuffer`](@ref)s are used here.

# Key word arguments

- `capacity`::Int, the maximum length of each trace.
- `state_type` = Int
- `state_size` = ()
- `action_type` = Int
- `action_size` = ()
- `reward_type` = Float32
- `reward_size` = ()
- `terminal_type` = Bool
- `terminal_size` = ()
"""
function CircularCompactSARTSATrajectory(;
    capacity,
    state_type = Int,
    state_size = (),
    action_type = Int,
    action_size = (),
    reward_type = Float32,
    reward_size = (),
    terminal_type = Bool,
    terminal_size = (),
)
    capacity > 0 || throw(ArgumentError("capacity must > 0"))
    reward = CircularArrayBuffer{reward_type}(reward_size..., capacity)
    terminal = CircularArrayBuffer{terminal_type}(terminal_size..., capacity)
    state = CircularArrayBuffer{state_type}(state_size..., capacity + 1)
    action = CircularArrayBuffer{action_type}(action_size..., capacity + 1)
    ts = NamedTuple{RTSA}((reward, terminal, state, action))

    CircularCompactSARTSATrajectory{
        Tuple{frame_type(state),frame_type(action),map(frame_type, ts)...},
        typeof(ts).parameters[2],
    }(
        ts,
    )
end

isfull(t::CircularCompactSARTSATrajectory) = isfull(t[:action])

Base.length(t::CircularCompactSARTSATrajectory) = nframes(t[:terminal])
