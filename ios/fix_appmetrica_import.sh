    #!/bin/bash
    GENERATED_FILE="/Users/marikdead/Documents/GitHub/Meal_app/ios/Runner/GeneratedPluginRegistrant.m"
    if [ -f "$GENERATED_FILE" ]; then
      sed -i '' 's/@import appmetrica_plugin;/#import <appmetrica_plugin/AMAFAppMetricaPlugin.h>/g' "$GENERATED_FILE"
      sed -i '' '/#if __has_include(<appmetrica_plugin/AMAFAppMetricaPlugin.h>)/,/^#endif$/d' "$GENERATED_FILE" || true
      # Добавляем прямой импорт если его нет
      if ! grep -q "#import <appmetrica_plugin/AMAFAppMetricaPlugin.h>" "$GENERATED_FILE"; then
        sed -i '' '/#import "GeneratedPluginRegistrant.h"/a#import <appmetrica_plugin/AMAFAppMetricaPlugin.h>
' "$GENERATED_FILE"
      fi
    fi
