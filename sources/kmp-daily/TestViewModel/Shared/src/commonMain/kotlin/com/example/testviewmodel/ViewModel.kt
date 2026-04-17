package com.example.testviewmodel

data class ViewState(val buttonIsLoading: Boolean)

interface ViewModel {
    val state: CommonStateFlow<ViewState>
    fun onButtonRClicked()
}
