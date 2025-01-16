using Godot;

public class SprintingState : WalkingState
{
    private float SprintMultiplier = 1.5f;
    public SprintingState(CharacterBody3D target, Node3D camera) : base(target, camera)
    {
    }

    public override void Enter()
    {
        Speed *= SprintMultiplier;
        base.Enter();
    }
    public override void Exit()
    {
        Speed /= SprintMultiplier;
        base.Exit();
    }

    public override void Update(double delta)
    {
        base.Update(delta);
    }
}
