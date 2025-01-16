using Godot;

public class PlayerStateMachine
{
    private readonly WalkingStateMachine walkingStateMachine;
    private readonly JumpingStateMachine jumpingStateMachine;
    private readonly CharacterBody3D target;

    public PlayerStateMachine(InputManager inputManager, CharacterBody3D target, Node3D camera)
    {
        walkingStateMachine = new WalkingStateMachine(inputManager, target, camera);
        jumpingStateMachine = new JumpingStateMachine(inputManager, target);
        this.target = target;
    }

    public void Update(double delta)
    {
        walkingStateMachine.Update(delta);
        jumpingStateMachine.Update(delta);

        target.MoveAndSlide();
    }
}