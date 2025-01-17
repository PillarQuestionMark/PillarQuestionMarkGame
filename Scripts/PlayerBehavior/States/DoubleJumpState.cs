using Godot;

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
		GD.Print("Entering Double Jump State");
		velocity = target.Velocity;
		velocity.Y = JumpImpulse;
		target.Velocity = velocity;
	}

	public override void Exit()
	{
		GD.Print("Exiting Double Jump State");
	}

	public override void Update(double delta)
	{
		velocity = target.Velocity;
		velocity.Y += gravity * (float)delta;
		target.Velocity = velocity;
	}
}
