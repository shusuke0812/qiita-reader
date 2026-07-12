package com.shusuke.qiitareader.presentation.screen.setting

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.fragment.app.Fragment
import com.shusuke.qiitareader.presentation.ResourceProvider
import com.shusuke.qiitareader.presentation.screen.setting.compose.SettingScreen
import com.shusuke.qiitareader.presentation.theme.QiitaReaderTheme
import org.koin.androidx.viewmodel.ext.android.viewModel

class SettingFragment : Fragment() {

    private val viewModel: SettingViewModel by viewModel()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return ComposeView(requireContext()).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                QiitaReaderTheme {
                    val uiState by viewModel.uiState.collectAsState()
                    val resourceProvider = remember { ResourceProvider(requireContext()) }
                    SettingScreen(
                        uiState = uiState,
                        resourceProvider = resourceProvider,
                        onLanguageSelected = viewModel::setLanguage
                    )
                }
            }
        }
    }
}
