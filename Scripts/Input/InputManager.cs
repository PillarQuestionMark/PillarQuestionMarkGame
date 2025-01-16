using Godot;
using System;
using System.Collections.Generic;

public partial class InputManager : Node
{
    public Action OnRightInputPressed;
    public Action OnLeftInputPressed;
    public Action OnUpInputPressed;
    public Action OnDownInputPressed;
    public Action OnJumpInputPressed;

    public Action OnRightInputReleased;
    public Action OnLeftInputReleased;
    public Action OnUpInputReleased;
    public Action OnDownInputReleased;
    public Action OnJumpInputReleased;

    public Action OnSprintInputPressed;
    public Action OnSprintInputReleased;

    private readonly Dictionary<string, Action> _inputPressedEvents = new Dictionary<string, Action>();
    private readonly Dictionary<string, Action> _inputReleasedEvents = new Dictionary<string, Action>();

    public override void _Ready()
    {
        _inputPressedEvents["move_right"] = OnRightInputPressed;
        _inputPressedEvents["move_left"] = OnLeftInputPressed;
        _inputPressedEvents["move_forward"] = OnUpInputPressed;
        _inputPressedEvents["move_backward"] = OnDownInputPressed;
        _inputPressedEvents["jump"] = OnJumpInputPressed;
        _inputPressedEvents["sprint"] = OnSprintInputPressed;


        _inputReleasedEvents["move_right"] = OnRightInputReleased;
        _inputReleasedEvents["move_left"] = OnLeftInputReleased;
        _inputReleasedEvents["move_forward"] = OnUpInputReleased;
        _inputReleasedEvents["move_backward"] = OnDownInputReleased;
        _inputReleasedEvents["jump"] = OnJumpInputReleased;
        _inputReleasedEvents["sprint"] = OnSprintInputReleased;
    }
    public override void _Process(double delta)
    {
        foreach (var action in _inputPressedEvents.Keys)
        {
            if (Input.IsActionPressed(action))
            {
                _inputPressedEvents[action]?.Invoke();
            }

            if (Input.IsActionJustReleased(action))
            {
                _inputReleasedEvents[action]?.Invoke();
            }
        }
    }
}
