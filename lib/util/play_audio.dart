import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Loading mp3 from assets folder:

    final manifestContent =
        await DefaultAssetBundle.of(context).loadString(Util.assetManifest);
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final fileNames = manifestMap.keys
        .where((String key) => key.contains('audios/'))
        .where((String key) => key.contains('.mp3'))
        .map((e) => e.substring(7))
        .toList();

 */

class PlayAudio {
  static final AudioPlayer gamePlayPlayer = AudioPlayer();
  static final AudioCache _gamePlayCache = AudioCache(
    fixedPlayer: gamePlayPlayer,
    respectSilence: true,
  );
  static final AudioCache _audioCache = AudioCache(
    respectSilence: true,
  );
  static final AudioPlayer _countdownPlayer = AudioPlayer();
  static final AudioCache _countDownCache =
      AudioCache(fixedPlayer: _countdownPlayer, respectSilence: true);

  static final String _gamePlayTune = 'audios/game_play.mp3';
  static final String _buttonClickTune = 'audios/button_click.mp3';
  static final String _gameOverTune = 'audios/game_over.mp3';
  static final String _countdownTune = 'audios/countdown.mp3';
  static final String _lifeLineTune = 'audios/life_line.mp3';
  static final String _rightAnswerTune = 'audios/right_answer.mp3';
  static final String _wrongAnswerTune = 'audios/wrong_answer.mp3';

  static final PlayAudio _self = PlayAudio._();
  static bool _isSoundEnabled;

  PlayAudio._() {
    _gamePlayCache.disableLog();
    _audioCache.disableLog();
    _countDownCache.disableLog();
  }

  factory PlayAudio({BuildContext context}) {
    if (context != null) {
      _loadAudios(context);
    }
    return _self;
  }

  bool get isSoundEnabled => _isSoundEnabled;

  gamePlay() async {
    loadVolumeSettings();
    if (_isSoundEnabled) {
      if (_gamePlayCache.fixedPlayer.state != AudioPlayerState.PLAYING) {
        await _gamePlayCache.loop(
          _gamePlayTune,
          volume:0.6,
        );
      }
    }
  }

  pause() async {
    if (_gamePlayCache.fixedPlayer.state == AudioPlayerState.PLAYING) {
      await _gamePlayCache.fixedPlayer.pause();
    }
  }

  resume() async {
    if (_gamePlayCache.fixedPlayer.state == AudioPlayerState.PAUSED) {
      await _gamePlayCache.fixedPlayer.resume();
    }
  }

  buttonClick() async {
    if (_isSoundEnabled) await _audioCache.play(_buttonClickTune, volume: 1.0);
  }

  countDown() async {
    if (_isSoundEnabled) await _countDownCache.play(_countdownTune, volume: 1.0);
  }

  lifeline() async {
    if (_isSoundEnabled) await _audioCache.play(_lifeLineTune, volume: 1.0);
  }

  gameOver() async {
    if (_isSoundEnabled) await _audioCache.play(_gameOverTune, volume: 1.0);
  }

  rightAnswer() async {
    if (_isSoundEnabled) await _audioCache.play(_rightAnswerTune, volume: 1.0);
  }

  wrongAnswer() async {
    if (_isSoundEnabled) await _audioCache.play(_wrongAnswerTune, volume: 1.0);
  }

  stopAll() {
    if (_gamePlayCache.fixedPlayer.state == AudioPlayerState.PLAYING) {
      _gamePlayCache.fixedPlayer.stop();
    }
    stopCountDown();
  }

  stopCountDown() {
    if (_countdownPlayer.state == AudioPlayerState.PLAYING) {
      _countdownPlayer.stop();
    }
  }

  void setVolume(bool val) {
    _isSoundEnabled = val;
    if (!_isSoundEnabled) {
      stopAll();
    } else {
      gamePlay();
    }
  }

  static void _loadAudios(BuildContext context) async {
    loadVolumeSettings();
    _audioCache.load(_buttonClickTune);
    _audioCache.load(_lifeLineTune);
    _audioCache.load(_rightAnswerTune);
    _audioCache.load(_wrongAnswerTune);

    _gamePlayCache.load(_gamePlayTune);
    _countDownCache.load(_countdownTune);
  }

  static void loadVolumeSettings() async {
    SharedPreferences volumePreferences = await SharedPreferences.getInstance();
    _isSoundEnabled = volumePreferences.getBool("sound") ?? true;
  }
}
