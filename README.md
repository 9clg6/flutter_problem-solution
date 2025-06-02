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
  
```<meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="default_channel_id" />```
  
et
  
```<intent-filter> <action android:name="FLUTTER_NOTIFICATION_CLICK" /> <category android:name="android.intent.category.DEFAULT" /> </intent-filter>```
- Mettre les clés dans tous les Manifest
- Bien addDevice APRES la demande de permissions

### Avoir un Ripple Effect (splash) qui a un borderRadius lors de l'utilisation d'un InkWell
- Toujours avoir un composant Material en parent DIRECT, qui contiendra la couleur final et les radius désirés. :
  ```
  return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () => onItemTap(tee),
        child: Container(
          padding: const EdgeInsets.all(16),
          child:

### Faire qu'une row prenne la hauteur de son parent et pas de la column la plus haute : 

Wrapping it inside a IntrinsicHeight
This will calculate your widget height and then pass it to the column 

No more infinite height error
