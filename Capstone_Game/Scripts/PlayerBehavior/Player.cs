using Godot;

public partial class Player : CharacterBody3D
{
    private PlayerStateMachine playerStateMachine;
    private InputManager inputManager = new();
    [Export] private Node3D camera;

    public override void _Ready()
    {
        base._Ready();
        playerStateMachine = new PlayerStateMachine(inputManager, this, camera);
        AddChild(inputManager);
    }

    public override void _PhysicsProcess(double delta)
    {
        playerStateMachine.Update(delta);
    }
}
