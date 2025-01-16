using Godot;

public class WalkingStateMachine
{
    private State currentState;
    public State CurrentState { get { return currentState; } set { currentState = value; } }
    private readonly CharacterBody3D target;
    private readonly Node3D camera;

    public WalkingStateMachine(InputManager inputManager, CharacterBody3D target, Node3D camera)
    {
        CurrentState = new IdleState(target);
        inputManager.OnRightInputPressed += HandleWalkInput;
        inputManager.OnLeftInputPressed += HandleWalkInput;
        inputManager.OnUpInputPressed += HandleWalkInput;
        inputManager.OnDownInputPressed += HandleWalkInput;

        inputManager.OnRightInputReleased += HandleWalkInputReleased;
        inputManager.OnLeftInputReleased += HandleWalkInputReleased;
        inputManager.OnUpInputReleased += HandleWalkInputReleased;
        inputManager.OnDownInputReleased += HandleWalkInputReleased;

        inputManager.OnSprintInputPressed += HandleSprintInput;
        inputManager.OnSprintInputReleased += HandleSprintInputReleased;

        this.target = target;
        this.camera = camera;
    }

    #region Walking
    private void HandleWalkInput()
    {
        AttemptToWalk();
    }

    private void HandleWalkInputReleased()
    {
        AttemptToStopWalking();
    }

    private void AttemptToWalk()
    {
        if (currentState is not WalkingState)
        {
            Walk();
        }
    }

    private void Walk()
    {
        ChangeWalkingState(new WalkingState(target, camera));
    }

    private void AttemptToStopWalking()
    {
        if (currentState is WalkingState)
        {
            StopWalking();
        }
    }

    private void StopWalking()
    {
        ChangeWalkingState(new IdleState(target));
    }
    #endregion

    #region Sprinting
    private void HandleSprintInput()
    {
        AttemptToSprint();
    }

    private void HandleSprintInputReleased()
    {
        AttemptToStopSprinting();
    }

    private void AttemptToSprint()
    {
        if (currentState is not SprintingState)
        {
            Sprint();
        }
    }

    private void Sprint()
    {
        ChangeWalkingState(new SprintingState(target, camera));
    }

    private void AttemptToStopSprinting()
    {
        if (currentState is SprintingState)
        {
            StopSprinting();
        }
    }

    private void StopSprinting()
    {
        ChangeWalkingState(new IdleState(target));
    }
    #endregion
    public void ChangeWalkingState(State newState)
    {
        currentState?.Exit();
        currentState = newState;
        currentState.Enter();
    }

    public void Update(double delta)
    {
        currentState.Update(delta);
    }
}
