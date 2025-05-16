# flutter_problem-solution
## Un problème ? La solution.

### Empêcher le repaint d'un widget
RepaintBoundary

### Notifications
Les notifications n'arrivent pas ? Vérifier :
- La configuration
- les credentials du compte de service
- les traductions
- la validité des template APN/Android
- bien mettre dans AndroidManifest:
  
\<meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="default_channel_id" />
  
et
  
\<intent-filter> \<action android:name="FLUTTER_NOTIFICATION_CLICK" /> \<category android:name="android.intent.category.DEFAULT" /> \</intent-filter>
- Mettre les clés dans tous les Manifest
- Bien addDevice APRES la demande de permissions
