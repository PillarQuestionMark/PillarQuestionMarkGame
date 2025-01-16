using Godot;

public class IdleState : State
{
    private readonly CharacterBody3D target;
    private Vector3 velocity;

    public IdleState(CharacterBody3D target)
    {
        this.target = target;
    }

    public override void Enter()
    {
        GD.Print("Entering Idle State");
        velocity = target.Velocity;
    }

    public override void Exit()
    {
        GD.Print("Exiting Idle State");
    }

    public override void Update(double delta)
    {
        velocity.X = Mathf.MoveToward(target.Velocity.X, 0, 2);
        velocity.Z = Mathf.MoveToward(target.Velocity.Z, 0, 2);
        velocity.Y = target.Velocity.Y;

        target.Velocity = velocity;
    }
}
