package com.shusuke.qiitareader.presentation.screen.setting

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView
import androidx.fragment.app.Fragment
import com.shusuke.qiitareader.presentation.screen.setting.compose.SettingScreen
import com.shusuke.qiitareader.presentation.theme.QiitaReaderTheme

class SettingFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return ComposeView(requireContext()).apply {
            setContent {
                QiitaReaderTheme {
                    SettingScreen()
                }
            }
        }
    }
}
