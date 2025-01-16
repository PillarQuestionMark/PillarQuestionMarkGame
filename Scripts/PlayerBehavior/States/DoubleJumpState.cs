using Godot;
using System.Collections.Generic;

public class DoubleJumpState : State
{
    private readonly CharacterBody3D target;
    private Vector3 velocity;
    private readonly float JumpImpulse = 15f;
    private readonly float gravity = -50f;
    public DoubleJumpState(CharacterBody3D target)
    {
        this.target = target;
    }

    public override void Enter()
    {
        DoubleJump();
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

    private void DoubleJump()
    {
        velocity = target.Velocity;
        velocity.Y = JumpImpulse;
        target.Velocity = velocity;

        var eventData = new Dictionary<string, object>();
        EventManager.Instance.Dispatch("DoubleJump", eventData);
    }
}
