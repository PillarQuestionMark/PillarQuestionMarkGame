using Godot;
using System.Collections.Generic;

public delegate void Notify();

public class JumpingState : State
{
    private readonly CharacterBody3D target;
    private Vector3 velocity;
    private readonly float JumpImpulse = 15;
    private readonly float gravity = -50f;
    public JumpingState(CharacterBody3D target)
    {
        this.target = target;
    }

    public override void Enter()
    {
        Jump();    
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

    private void Jump()
    {
        velocity = target.Velocity;
        velocity.Y = JumpImpulse;
        target.Velocity = velocity;

        var eventData = new Dictionary<string, object>();
        EventManager.Instance.Dispatch("Jump", eventData);
    }
}
