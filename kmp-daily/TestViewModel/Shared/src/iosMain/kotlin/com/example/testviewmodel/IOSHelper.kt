package com.example.testviewmodel

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel

class IOSHelper {
    fun createCoroutineScope() = CoroutineScope(Dispatchers.Default)

    fun cancelCoroutineScope(scope: CoroutineScope) {
        println("get job on cancel begin")
try {
    val job = scope.coroutineContext[Job]
    job.cancel()
    println("get job on cancel" + job)



    scope.cancel()
} catch (e: Exception) {
    println("get job on cancel error" + e)
}


    }

    fun run() {
        println("run ios helper")
    }

    fun provdeViewModel(scope: CoroutineScope): ViewModel = ViewModelImpl(scope)
}