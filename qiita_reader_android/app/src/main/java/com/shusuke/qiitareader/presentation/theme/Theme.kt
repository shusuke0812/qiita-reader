package com.shusuke.qiitareader.presentation.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext

private val DarkColorScheme = darkColorScheme(
    primary = DevBlue600,
    secondary = DevGrey600,
    tertiary = DevBlue700,
    background = DevGrey900,
    surface = DevGrey800,
    surfaceVariant = DevGrey800,
    onPrimary = Color.White,
    onSecondary = DevGrey50,
    onTertiary = Color.White,
    onBackground = DevGrey50,
    onSurface = DevGrey50,
    onSurfaceVariant = DevGrey400,
    outline = DevGrey600
)

private val LightColorScheme = lightColorScheme(
    primary = DevBlue600,
    secondary = DevGrey600,
    tertiary = DevBlue700,
    background = DevGrey50,
    surface = Color.White,
    onPrimary = Color.White,
    onSecondary = DevGrey900,
    onTertiary = Color.White,
    onBackground = DevGrey900,
    onSurface = DevGrey900,
    onSurfaceVariant = DevGrey600,
    outline = DevGrey400,
    surfaceVariant = DevGrey100
)

@Composable
fun QiitaReaderTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = false,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }

        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}