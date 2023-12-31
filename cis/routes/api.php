<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\IzinKeluarController;
use App\Http\Controllers\IzinBermalamController;
use App\Http\Controllers\RequestSuratController;
use App\Http\Controllers\BookingRuanganController;
use App\Http\Controllers\BookingBajuController;
use App\Http\Controllers\RuanganController;



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
    
    //Mahasiswa
    Route::get('/izinkeluar',[IzinKeluarController::class, 'index']);
    Route::post('/izinkeluar',[IzinKeluarController::class, 'store']);
    Route::put('/izinkeluar/{id}',[IzinKeluarController::class, 'update']);
    Route::get('/izinkeluar/{id}',[IzinKeluarController::class, 'show']);
    Route::delete('/izinkeluar/{id}',[IzinKeluarController::class, 'destroy']);  

    //Baak
    Route::get('/izin-keluar/all', [IzinKeluarController::class, 'viewAllRequestsForBaak']);
    Route::put('/izin-keluar/{id}/approve', [IzinKeluarController::class, 'approveIzinKeluar']);
    Route::put('/izin-keluar/{id}/reject', [IzinKeluarController::class, 'rejectIzinKeluar']);

    //Mahasiswa
    Route::get('/izinbermalam',[IzinBermalamController::class, 'index']);
    Route::post('/izinbermalam',[IzinBermalamController::class, 'store']);
    Route::put('/izinbermalam/{id}',[IzinBermalamController::class, 'update']);
    Route::get('/izinbermalam/{id}',[IzinBermalamController::class, 'show']);
    Route::delete('/izinbermalam/{id}',[IzinBermalamController::class, 'destroy']);

    Route::get('/getmahasiswa', [IzinKeluarController::class, 'getMahasiswa']);

    Route::get('/getruangan', [IzinKeluarController::class, 'getRuangan']);




    //Baak
    Route::get('/izin-bermalam/all', [IzinBermalamController::class, 'viewAllRequestsForBaak']);
    Route::put('/izin-bermalam/{id}/approve', [IzinBermalamController::class, 'approveIzinBermalam']);
    Route::put('/izin-bermalam/{id}/reject', [IzinBermalamController::class, 'rejectIzinBermalam']);


    //Mahasiswa
    Route::get('/requestsurat', [RequestSuratController::class, 'index']);
    Route::post('/requestsurat', [RequestSuratController::class, 'store']);
    Route::get('/requestsurat/{id}', [RequestSuratController::class, 'show']);
    Route::put('/requestsurat/{id}', [RequestSuratController::class, 'update']);
    Route::delete('/requestsurat/{id}', [RequestSuratController::class, 'destroy']);

    //Baak
    Route::get('/request-surat/all', [RequestSuratController::class, 'viewAllRequestsForBaak']);
    Route::put('/request-surat/{id}/approve', [RequestSuratController::class, 'approveRequestSurat']);
    Route::put('/request-surat/{id}/reject', [RequestSuratController::class, 'rejectRequestSurat']);

    //Mahasiswa
    Route::get('/booking-ruangan', [BookingRuanganController::class, 'index']);
    Route::post('/booking-ruangan', [BookingRuanganController::class, 'bookRoom']);
    Route::delete('/booking-ruangan/{id}', [BookingRuanganController::class, 'destroy']);
    Route::post('/cek-ruangan', [BookingRuanganController::class, 'RoomAvailable']);

    Route::get('/getRuangan', [RuanganController::class, 'index']);

    //Baak
    Route::get('/booking-ruangan/all', [BookingRuanganController::class, 'viewAllRequestsForBaak']);
    Route::put('/booking-ruangan/{id}/approve', [BookingRuanganController::class, 'approveBookingRuangan']);
    Route::put('/booking-ruangan/{id}/reject', [BookingRuanganController::class, 'rejectBookingRuangan']);
    

    //Mahasiswa
    Route::get('/bookingbaju',[BookingBajuController::class, 'index']);
    Route::post('/bookingbaju',[BookingBajuController::class, 'store']);
    Route::put('/bookingbaju/{id}',[BookingBajuController::class, 'update']);
    Route::get('/bookingbaju/{id}',[BookingBajuController::class, 'show']);
    Route::delete('/bookingbaju/{id}',[BookingBajuController::class, 'destroy']);  

    Route::get('/ukuran-baju', [BookingBajuController::class, 'getBaju']);

    //Baak
    Route::get('/booking-baju/all', [BookingBajuController::class, 'viewAllRequestsForBaak']);
    Route::put('/booking-baju/{id}/approve', [BookingBajuController::class, 'approveBookingBaju']);
    Route::put('/booking-baju/{id}/reject', [BookingBajuController::class, 'rejectBookingBaju']);
});

