using Godot;
using static Godot.WebSocketPeer;

public class JumpingStateMachine
{
    private State currentState;
    public State CurrentState { get { return currentState; } set { currentState = value; } }
    private readonly CharacterBody3D target;
    private bool canDoubleJump = false;
    private float doubleJumpCooldownTime = 0.2f; // 200ms cooldown time
    private float doubleJumpCooldownTimer = 0f;

    public JumpingStateMachine(InputManager inputManager, CharacterBody3D target)
    {
        CurrentState = new FallingState(target);
        inputManager.OnJumpInputPressed += HandleJumpInput;
        this.target = target;
    }
    private void HandleJumpInput()
    {
        AttemptToJump();
    }

    private void AttemptToJump()
    {
        if (target.IsOnFloor())
        {
            if (currentState is not JumpingState)
            {
                Jump();
            }
        }
        else
        {
            AttemptToDoubleJump();
        }
    }

    private void Jump()
    {
        ChangeJumpingState(new JumpingState(target));
        canDoubleJump = true;
        doubleJumpCooldownTimer = doubleJumpCooldownTime;
    }

    private void AttemptToDoubleJump()
    {
        if (canDoubleJump && doubleJumpCooldownTimer <= 0f)
        {
            if (currentState is not DoubleJumpState)
            {
                DoubleJump();
            }
        }
    }

    private void DoubleJump()
    {
        ChangeJumpingState(new DoubleJumpState(target));
        canDoubleJump = false;
    }

    private void StartFalling()
    {
        if (currentState is not FallingState)
        {
            ChangeJumpingState(new FallingState(target));
        }
    }

    public void ChangeJumpingState(State newState)
    {
        CurrentState?.Exit();
        CurrentState = newState;
        CurrentState.Enter();
    }

    public void Update(double delta)
    {
        currentState.Update(delta);
        if (target.Velocity.Y <= 0)
        {
            StartFalling();
        }

        if (doubleJumpCooldownTimer > 0f)
        {
            doubleJumpCooldownTimer -= (float)delta;
        }
    }
}
