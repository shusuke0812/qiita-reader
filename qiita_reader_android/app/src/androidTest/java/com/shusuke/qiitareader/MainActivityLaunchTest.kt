package com.shusuke.qiitareader

import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.lifecycle.Lifecycle
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

/**
 * アプリが起動できることを確認する UI テスト。
 * MainActivity がクラッシュせず RESUMED まで遷移すれば成功。
 */
@RunWith(AndroidJUnit4::class)
class MainActivityLaunchTest {

    @get:Rule
    val activityScenarioRule = ActivityScenarioRule(MainActivity::class.java)

    @Test
    fun appLaunches_success() {
        activityScenarioRule.scenario.onActivity { activity ->
            assert(activity != null)
        }
        assert(activityScenarioRule.scenario.state == Lifecycle.State.RESUMED)
        Thread.sleep(3000) // エミュレータでアプリが起動していることを目視で確認したいため
    }
}
