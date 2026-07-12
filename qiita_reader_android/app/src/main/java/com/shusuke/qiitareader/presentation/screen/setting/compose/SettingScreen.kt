package com.shusuke.qiitareader.presentation.screen.setting.compose

import androidx.annotation.StringRes
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Language
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.shusuke.qiitareader.R
import com.shusuke.qiitareader.presentation.theme.DevGrey400
import com.shusuke.qiitareader.presentation.theme.DevGrey50
import com.shusuke.qiitareader.presentation.theme.DevGrey800

enum class AppLanguage(@StringRes val nameResId: Int) {
    JAPANESE(R.string.language_japanese),
    ENGLISH(R.string.language_english)
}

@Composable
fun SettingScreen() {
    var selectedLanguage by remember { mutableStateOf(AppLanguage.JAPANESE) }
    var showLanguageDialog by remember { mutableStateOf(false) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(DevGrey50)
    ) {
        SettingSection(title = stringResource(R.string.setting_section_language_region)) {
            LanguageSettingCell(
                currentLanguage = selectedLanguage,
                onClick = { showLanguageDialog = true }
            )
        }
    }

    if (showLanguageDialog) {
        LanguageDialog(
            currentLanguage = selectedLanguage,
            onConfirm = { language ->
                selectedLanguage = language
                showLanguageDialog = false
            },
            onDismiss = { showLanguageDialog = false }
        )
    }
}

@Composable
private fun SettingSection(
    title: String,
    content: @Composable () -> Unit
) {
    HorizontalDivider()
    Text(
        text = title,
        style = MaterialTheme.typography.labelMedium,
        color = DevGrey400,
        modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)
    )
    content()
    HorizontalDivider()
}

@Composable
private fun LanguageSettingCell(
    currentLanguage: AppLanguage,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = Icons.Default.Language,
            contentDescription = null,
            modifier = Modifier.size(20.dp),
            tint = DevGrey800
        )
        Spacer(modifier = Modifier.width(12.dp))
        Text(
            text = stringResource(R.string.setting_display_language),
            style = MaterialTheme.typography.bodyMedium,
            color = DevGrey800,
            modifier = Modifier.weight(1f)
        )
        Text(
            text = stringResource(currentLanguage.nameResId),
            style = MaterialTheme.typography.bodyMedium,
            color = DevGrey400
        )
    }
}

@Composable
private fun LanguageDialog(
    currentLanguage: AppLanguage,
    onConfirm: (AppLanguage) -> Unit,
    onDismiss: () -> Unit
) {
    var selectedLanguage by remember { mutableStateOf(currentLanguage) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.setting_display_language)) },
        text = {
            Column {
                AppLanguage.entries.forEach { language ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { selectedLanguage = language }
                            .padding(vertical = 4.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(
                            selected = selectedLanguage == language,
                            onClick = { selectedLanguage = language }
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = stringResource(language.nameResId),
                            style = MaterialTheme.typography.bodyMedium
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { onConfirm(selectedLanguage) }) {
                Text(stringResource(R.string.ok))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.cancel))
            }
        }
    )
}
