package com.shusuke.qiitareader.presentation.screen.setting

import androidx.annotation.StringRes
import com.shusuke.qiitareader.R
import java.util.Locale

enum class AppLanguage(@StringRes val nameResId: Int) {
    JAPANESE(R.string.language_japanese),
    ENGLISH(R.string.language_english);

    fun toLocale(): Locale = when (this) {
        JAPANESE -> Locale.JAPANESE
        ENGLISH -> Locale.ENGLISH
    }
}
