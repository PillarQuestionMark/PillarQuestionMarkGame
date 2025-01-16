using Godot;

public class WalkingState : State
{
    private CharacterBody3D target;
    private Vector3 velocity;
    private float speed = 20f;
    public float Speed{ get { return speed; } set { speed = value; } }
    private readonly float Deceleration = 0.20f;
    private Node3D camera;

    public WalkingState(CharacterBody3D target, Node3D camera)
    {
        this.target = target;
        this.camera = camera;   

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
        Walk();
    }

    public void Walk()
    {
        Vector3 input = Vector3.Zero;
        input.X = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");
        input.Z = Input.GetActionStrength("move_forward") - Input.GetActionStrength("move_backward");

        Vector3 forward = -camera.GlobalTransform.Basis.Z.Normalized();
        Vector3 right = camera.GlobalTransform.Basis.X.Normalized();

        Vector3 moveDirection = forward * input.Z + right * input.X;
        moveDirection = moveDirection.Normalized();

        velocity.X = Mathf.Lerp(velocity.X, moveDirection.X * Speed, Deceleration);
        velocity.Z = Mathf.Lerp(velocity.Z, moveDirection.Z * Speed, Deceleration);

        velocity.Y = target.Velocity.Y;
        target.Velocity = velocity;
    }
}
