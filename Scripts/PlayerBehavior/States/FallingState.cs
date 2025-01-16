using Godot;

public class FallingState : State
{
    private readonly CharacterBody3D target;
    private Vector3 velocity;
    private readonly float gravity = -50f;
    public FallingState(CharacterBody3D target)
    {
        this.target = target;
    }

    public override void Enter()
    {
        velocity = target.Velocity;
    }

    public override void Exit()
    {
    }

    public override void Update(double delta)
    {
        velocity = target.Velocity;
        velocity.Y += gravity * (float)delta;
        target.Velocity = velocity;
    }
}
