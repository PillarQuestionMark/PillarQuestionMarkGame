using Godot;
using System;
using System.Collections.Generic;

public partial class AudioManager : Node
{
    private Dictionary<string, AudioStreamPlayer> audioPlayers = new Dictionary<string, AudioStreamPlayer>();

    public override void _Ready()
    {
        audioPlayers["JumpSFX"] = GetNode<AudioStreamPlayer>("SoundEffects/JumpSFX");
        audioPlayers["DoubleJumpSFX"] = GetNode<AudioStreamPlayer>("SoundEffects/DoubleJumpSFX");

        #region subscriptions
        EventManager.Instance.Subscribe("Jump", OnJump);
        EventManager.Instance.Subscribe("DoubleJump", OnDoubleJump);
        #endregion
    }

    private void OnJump(Dictionary<string, object> eventData)
    {
        audioPlayers["JumpSFX"].Play();
    }

    private void OnDoubleJump(Dictionary<string, object> eventData)
    {
        audioPlayers["DoubleJumpSFX"].Play();
    }
}
