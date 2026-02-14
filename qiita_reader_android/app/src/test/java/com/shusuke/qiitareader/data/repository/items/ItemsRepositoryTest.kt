package com.shusuke.qiitareader.data.repository.items

import com.shusuke.qiitareader.data.infrastructure.api.ApiError
import com.shusuke.qiitareader.data.infrastructure.qiitaapi.QiitaApiService
import io.mockk.coEvery
import io.mockk.coVerify
import io.mockk.mockk
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import retrofit2.HttpException
import java.io.IOException

class ItemsRepositoryTest {

    private val api = mockk<QiitaApiService>()
    private val repository = ItemsRepository(api = api)

    @Test
    fun getItems_success_returnsItemList() {
        runTest {
        val expectedItems = listOf(
            sampleItem(id = "1", title = "title1"),
            sampleItem(id = "2", title = "title2")
        )
        coEvery {
            api.getItems(page = 1, perPage = 20, query = "Kotlin")
        } returns expectedItems

        val result = repository.getItemsFlow(page = 1, query = "Kotlin").first()

        assertTrue(result.isSuccess)
        assertEquals(2, result.getOrNull()?.list?.size)
        assertEquals("title1", result.getOrNull()?.list?.get(0)?.title)
        assertEquals("title2", result.getOrNull()?.list?.get(1)?.title)
        coVerify(exactly = 1) { api.getItems(page = 1, perPage = 20, query = "Kotlin") }
        }
    }

    @Test
    fun getItems_success_emptyList_returnsEmptyItemList() {
        runTest {
        coEvery { api.getItems(page = 1, perPage = 20, query = "query") } returns emptyList()

        val result = repository.getItemsFlow(page = 1, query = "query").first()

        assertTrue(result.isSuccess)
        assertTrue(result.getOrNull()?.list?.isEmpty() == true)
        }
    }

    @Test
    fun getItems_ioException_returnsFailureWithNetworkError() {
        runTest {
        val ioException = IOException("Connection timeout")
        coEvery { api.getItems(page = 1, perPage = 20, query = "q") } throws ioException

        val result = repository.getItemsFlow(page = 1, query = "q").first()

        assertTrue(result.isFailure)
        val error = result.exceptionOrNull()
        assertTrue(error is ApiError.NetworkError)
        assertEquals(ioException, (error as ApiError.NetworkError).cause)
        }
    }

    @Test
    fun getItems_httpException_4xx_returnsFailureWithInvalidRequest() {
        runTest {
        val httpException = mockk<HttpException>(relaxed = true)
        coEvery { httpException.code() } returns 404
        coEvery { httpException.message } returns "Not Found"
        coEvery { api.getItems(page = 1, perPage = 20, query = "q") } throws httpException

        val result = repository.getItemsFlow(page = 1, query = "q").first()

        assertTrue(result.isFailure)
        val error = result.exceptionOrNull()
        assertTrue(error is ApiError.InvalidRequest)
        assertEquals(404, (error as ApiError.InvalidRequest).statusCode)
        }
    }

    @Test
    fun getItems_httpException_5xx_returnsFailureWithServerError() {
        runTest {
        val httpException = mockk<HttpException>(relaxed = true)
        coEvery { httpException.code() } returns 503
        coEvery { httpException.message } returns "Service Unavailable"
        coEvery { api.getItems(page = 1, perPage = 20, query = "q") } throws httpException

        val result = repository.getItemsFlow(page = 1, query = "q").first()

        assertTrue(result.isFailure)
        val error = result.exceptionOrNull()
        assertTrue(error is ApiError.ServerError)
        assertEquals(503, (error as ApiError.ServerError).statusCode)
        }
    }

    @Test
    fun getItems_unknownException_returnsFailureWithUnknown() {
        runTest {
        coEvery { api.getItems(page = 1, perPage = 20, query = "q") } throws RuntimeException("unexpected")

        val result = repository.getItemsFlow(page = 1, query = "q").first()

        assertTrue(result.isFailure)
        val error = result.exceptionOrNull()
        assertTrue(error is ApiError.Unknown)
        }
    }

    private fun sampleItem(
        id: String = "id",
        title: String = "title",
        urlString: String = "https://example.com"
    ) = Item(
        id = id,
        likesCount = 0,
        tags = listOf(Item.Tag(name = "tag")),
        title = title,
        updatedAtString = "2025-01-01T00:00:00+09:00",
        urlString = urlString,
        user = Item.User(id = "user1", profileImageUrlString = "https://example.com/icon.png")
    )
}
