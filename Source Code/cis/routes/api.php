<?php
use App\Http\Controllers\AuthController;
use App\Http\Controllers\IzinkeluarController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth; 
use Illuminate\Support\Facades\Route;

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


Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);




Route::get('/auth/users', [AuthController::class, 'getAllUsers']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});





Route::middleware('auth:sanctum')->post('/izin-keluar/request', [IzinkeluarController::class, 'requestIzinKeluar']);
Route::middleware('auth:sanctum')->get('/izin-keluar/request', [IzinkeluarController::class, 'requestIzinKeluar']);
Route::middleware('auth:sanctum')->get('/izin-keluar/all', [IzinkeluarController::class, 'getAllIzinKeluar']);
Route::middleware('auth:sanctum')->put('/izin-keluar/{izinId}/approve', [IzinkeluarController::class, 'approveIzinKeluar']);


Route::middleware('auth:sanctum')->put('/izin-keluar/approve/{izinId}', [IzinkeluarController::class, 'approveIzinKeluar']);
