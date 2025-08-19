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

### Configurer Firebase pour plusieurs flavor/env :

- flutterfire configure \
  --project=x \
  --out=lib/application/config/firebase_options_prod.dart \
  --ios-bundle-id=x \
  --ios-out=ios/flavors/prod/GoogleService-Info.plist \
  --android-package-name=x \
  --android-out=android/app/src/prod/google-services.json \
  --platforms=android,ios

avec
- GoogleService-Info.plist & google-services.json dans les bons dossiers
- firebase.json avec les build configurations :
- 
  ```
  {
  "flutter": {
    "platforms": {
      "android": {
        "buildConfigurations": {
          "src/dev": {
            "projectId": x-x",
            "appId": "1:x",
            "fileOutput": "android/app/src/dev/google-services.json"
          },
          "src/staging": {
            "projectId": "x-x",
            "appId": "1:x",
            "fileOutput": "android/app/src/staging/google-services.json"
          },
          "src/prod": {
            "projectId": "x-x",
            "appId": "1:x",
            "fileOutput": "android/app/src/prod/google-services.json"
          }
        }
      },
      "ios": {
        "buildConfigurations": {
          "Debug-dev": {
            "projectId": "x-x",
            "appId": "1:x",
            "uploadDebugSymbols": true,
            "fileOutput": "ios/config/dev/GoogleService-Info.plist"
          },
          "Debug-staging": {
            "projectId": "x-x",
            "appId": "1:x",
            "uploadDebugSymbols": true,
            "fileOutput": "ios/config/staging/GoogleService-Info.plist"
          },
          "Debug-prod": {
            "projectId": "x-x",
            "appId": "1:x",
            "uploadDebugSymbols": true,
            "fileOutput": "ios/config/prod/GoogleService-Info.plist"
          },
          "Release-dev": {
            "projectId": "x-x",
            "appId": "1:x",
            "uploadDebugSymbols": true,
            "fileOutput": "ios/config/dev/GoogleService-Info.plist"
          },
          "Release-staging": {
            "projectId": "x-x",
            "appId": "1:x",
            "uploadDebugSymbols": true,
            "fileOutput": "ios/config/staging/GoogleService-Info.plist"
          },
          "Release-prod": {
            "projectId": "x-x",
            "appId": "1:x",
            "uploadDebugSymbols": true,
            "fileOutput": "ios/config/prod/GoogleService-Info.plist"
          }
        }
      },
      "dart": {
        "lib/application/config/firebase_options_dev.dart": {
          "projectId": "x-x",
          "configurations": {
            "ios": "1:x"
          }
        },
        "lib/application/config/firebase_options_preprod.dart": {
          "projectId": "x-x",
          "configurations": {
            "ios": "1:x"
          }
        },
        "lib/application/config/firebase_options_prod.dart": {
          "projectId": "x-x",
          "configurations": {
            "ios": "1:x"
          }
        }
      }
    }
  }
}

- Si on reçoit pas la notification push FCM, vérifier si :
  - On a bien configuré la clé APN (.p8) sur Firebase Messaging. Attention il peut seulement être DL une fois, donc bien le stocker lors de la configuration


 ### Git

 - Pour garder toutes les modifications de sa branche en recuperant les nouveaux fichiers de l'autre branche : 
git merge -X ours origin/main

