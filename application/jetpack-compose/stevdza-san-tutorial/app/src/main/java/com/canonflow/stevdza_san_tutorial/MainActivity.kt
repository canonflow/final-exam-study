package com.canonflow.stevdza_san_tutorial

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.canonflow.stevdza_san_tutorial.ui.theme.StevdzasantutorialTheme
import com.canonflow.stevdza_san_tutorial.ui.theme.Typography

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            StevdzasantutorialTheme {
//                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
//
//                }
                Surface(color = MaterialTheme.colorScheme.background) {
//                    Column(
//                        modifier = Modifier
//                            .height(500.dp)
//                            .width(500.dp)
//                            .background(Color.LightGray),
//                        horizontalAlignment = Alignment.CenterHorizontally,
//                    ){
//                        CustomColItem(weight = 3f, color = MaterialTheme.colorScheme.secondary)
//                        CustomColItem(weight = 1f)
//                    }
                    Row(
                        modifier = Modifier
                            .height(100.dp)
                            .width(500.dp)
                            .background(Color.LightGray),
                        horizontalArrangement = Arrangement.Start,
                    ) {
                        CustomRowItem(weight = 3f, color = MaterialTheme.colorScheme.secondary)
                        CustomRowItem(weight = 1f)
                    }
                }
            }
        }
    }
}

// Use ColumnScope extension to use weight modifier
@Composable
fun ColumnScope.CustomColItem(
    weight: Float,
    color: Color = MaterialTheme.colorScheme.primary
) {
    Surface(
        modifier = Modifier
            .width(500.dp)
            .weight(weight),
        color = color
    ) {}
}

@Composable
fun RowScope.CustomRowItem(
    weight: Float,
    color: Color = MaterialTheme.colorScheme.primary
) {
    Surface(
        modifier = Modifier
            .width(50.dp)
            .height(50.dp)
            .weight(weight),
        color = color
    ) {}
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
//    Column(
//        modifier = Modifier.fillMaxSize(),
//        horizontalAlignment = Alignment.CenterHorizontally,
//    ){
//        CustomItem(weight = 3f, color = MaterialTheme.colorScheme.secondary)
//        CustomItem(weight = 1f)
//    }
    Row(
        modifier = Modifier.fillMaxSize(),
        horizontalArrangement = Arrangement.Start,
        verticalAlignment = Alignment.CenterVertically
    ){
        CustomRowItem(weight = 3f, color = MaterialTheme.colorScheme.secondary)
        CustomRowItem(weight = 1f)
    }
}