import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

///
/// [MessagingService] - Service de gestion des notifications FCM
/// Conforme à la documentation Firebase Cloud Messaging Flutter
///
final class MessagingService {
  /// Constructor
  MessagingService({required FirebaseMessaging messaging})
    : _messaging = messaging,Ï
      _token = ValueNotifier<String?>(null) {
    _setupListeners();
  }

  final FirebaseMessaging _messaging;
  final ValueNotifier<String?> _token;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;

  /// Token FCM actuel
  String? get token => _token.value;

  /// Status d'autorisation des notifications
  final ValueNotifier<bool> isNotifAuthorized = ValueNotifier<bool>(false);

  /// Stream des IDs de posts depuis les notifications
  final BehaviorSubject<String> _postIdNotif = BehaviorSubject<String>();

  /// Stream des messages reçus au premier plan
  final BehaviorSubject<RemoteMessage> _foregroundMessages =
      BehaviorSubject<RemoteMessage>();

  /// Getters pour les streams
  Stream<String> get postIdNotif => _postIdNotif.stream.asBroadcastStream();

  /// Stream des messages reçus au premier plan
  Stream<RemoteMessage> get foregroundMessages =>
      _foregroundMessages.stream.asBroadcastStream();

  /// Configuration des listeners selon la documentation Firebase
  void _setupListeners() {
    // Listener pour le refresh du token
    _tokenSubscription = _messaging.onTokenRefresh.listen(_onTokenRefresh);

    // Listener pour les messages au premier plan
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _onForegroundMessage,
    );

    // Listener pour les messages qui ouvrent l'app
    _messageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _onMessageOpenedApp,
    );

    // Listener du cycle de vie de l'app
    AppLifecycleListener(
      onStateChange: (AppLifecycleState state) async {
        if (state == AppLifecycleState.resumed) {
          await _checkAuthorizationStatus();
          await _refreshTokenIfNeeded();
        }
      },
    );
  }

  /// Gestion du refresh du token
  Future<void> _onTokenRefresh(String token) async {
    debugPrint('Token FCM mis à jour: $token');
    if (isNotifAuthorized.value) {
      _token.value = token;
      // TODO(clement): envoyer le token
    }
  }

  /// Gestion des messages reçus au premier plan
  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('Message reçu au premier plan: ${message.messageId}');
    debugPrint('Titre: ${message.notification?.title}');
    debugPrint('Corps: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    _foregroundMessages.add(message);

    // Traiter les données personnalisées
    if (message.data.containsKey('postId')) {
      _postIdNotif.add(message.data['postId'] as String);
    }
  }

  /// Gestion des messages qui ouvrent l'app
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Message ouvert app: ${message.messageId}');
    debugPrint('Data: ${message.data}');

    // Traiter les données personnalisées
    if (message.data.containsKey('postId')) {
      _postIdNotif.add(message.data['postId'] as String);
    }
  }

  /// Vérifier le statut d'autorisation
  Future<void> _checkAuthorizationStatus() async {
    final NotificationSettings settings = await _messaging
        .getNotificationSettings();
    isNotifAuthorized.value =
        settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Rafraîchir le token si nécessaire
  Future<void> _refreshTokenIfNeeded() async {
    if (isNotifAuthorized.value) {
      final String? newToken = await _messaging.getToken();
      if (_token.value != newToken) {
        _token.value = newToken;
      }
    }
  }

  /// Initialisation du service selon la documentation Firebase
  Future<void> init() async {
    try {
      debugPrint('[MessagingService] Initialisation du service FCM');
      final NotificationSettings settings = await _messaging.requestPermission(
        provisional: true,
        criticalAlert: true,
        announcement: true,
        providesAppNotificationSettings: true,
      );

      isNotifAuthorized.value =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (isNotifAuthorized.value) {
        debugPrint('[MessagingService] Autorisation des notifications');
        if (Platform.isIOS) {
          final String? apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            debugPrint(
              '[MessagingService] Token APNS non disponible, attente...',
            );
            await Future<void>.delayed(const Duration(seconds: 3));
          } else {
            debugPrint('[MessagingService] Token APNS disponible: $apnsToken');
          }
        }

        _token.value = await _messaging.getToken();
        debugPrint('[MessagingService] Token FCM initial: ${_token.value}');

        final RemoteMessage? initialMessage = await _messaging
            .getInitialMessage();

        if (initialMessage != null) {
          _onMessageOpenedApp(initialMessage);
        }
      } else {
        debugPrint('[MessagingService] Autorisation des notifications refusée');
      }
    } on Exception catch (e) {
      debugPrint("[MessagingService] Erreur lors de l'initialisation FCM: $e");
    }
  }

  /// Nettoyer les ressources
  void dispose() {
    _tokenSubscription?.cancel();
    _foregroundSubscription?.cancel();
    _messageOpenedAppSubscription?.cancel();
    _postIdNotif.close();
    _foregroundMessages.close();
    _token.dispose();
    isNotifAuthorized.dispose();
  }
}
