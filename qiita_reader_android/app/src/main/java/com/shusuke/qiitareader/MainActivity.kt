package com.shusuke.qiitareader

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.shusuke.qiitareader.data.repository.language.LanguageRepository
import com.shusuke.qiitareader.presentation.ResourceProvider
import kotlinx.coroutines.launch
import org.koin.android.ext.android.inject

class MainActivity : FragmentActivity(R.layout.activity_main) {

    private val languageRepository: LanguageRepository by inject()
    private val resourceProvider: ResourceProvider by inject()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        val navHostFragment = supportFragmentManager.findFragmentById(R.id.nav_host_fragment) as NavHostFragment
        val navController = navHostFragment.navController
        val bottomNavigation = findViewById<BottomNavigationView>(R.id.bottom_navigation_view)
        bottomNavigation.setupWithNavController(navController)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.nav_host_fragment)) { view, insets ->
            val statusBarHeight = insets.getInsets(WindowInsetsCompat.Type.statusBars()).top
            view.setPadding(0, statusBarHeight, 0, 0)
            insets
        }

        lifecycleScope.launch {
            languageRepository.currentLanguage.collect { language ->
                bottomNavigation.menu.findItem(R.id.nav_search)?.title =
                    resourceProvider.getString(R.string.nav_search, language)
                bottomNavigation.menu.findItem(R.id.nav_setting)?.title =
                    resourceProvider.getString(R.string.nav_setting, language)
            }
        }
    }
}
