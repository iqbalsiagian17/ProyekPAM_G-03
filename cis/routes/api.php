<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\IzinKeluarController;



/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);
Route::get('/login',[AuthController::class,'login']);


Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);



Route::middleware('auth:sanctum')->group(function () {
    Route::get('/izinkeluar',[IzinKeluarController::class, 'index']);
    Route::post('/izinkeluar',[IzinKeluarController::class, 'store']);
    Route::put('/izinkeluar/{id}',[IzinKeluarController::class, 'update']);
    Route::get('/izinkeluar/{id}',[IzinKeluarController::class, 'show']);
    Route::delete('/izinkeluar/{id}',[IzinKeluarController::class, 'destroy']);  
});
