using Godot;
using System;
using System.Collections.Generic;

public partial class EventManager : Node
{
    public delegate void EventAction(Dictionary<string, object> eventData);
    private Dictionary<string, EventAction> eventListeners = new Dictionary<string, EventAction>();

    public static EventManager Instance { get; private set; }

    public override void _Ready()
    {
        Instance = this;
    }

    public void Subscribe(string eventType, EventAction listener)
    {
        if (!eventListeners.ContainsKey(eventType))
        {
            eventListeners[eventType] = listener;
        }
        else
        {
            eventListeners[eventType] += listener;
        }
    }

    public void Unsubscribe(string eventType, EventAction listener)
    {
        if (eventListeners.ContainsKey(eventType))
        {
            eventListeners[eventType] -= listener;
        }
    }

    public void Dispatch(string eventType, Dictionary<string, object> eventData)
    {
        if (eventListeners.ContainsKey(eventType))
        {
            eventListeners[eventType].Invoke(eventData);
        }
    }
}
        