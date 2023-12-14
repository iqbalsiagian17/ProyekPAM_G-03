<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RuanganBooking; 
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class BookingRuanganController extends Controller
{
    public function index()
    {
        // Mendapatkan pengguna yang sedang login
        $user = Auth::user();

        // Mengambil data booking ruangan sesuai dengan user yang login
        $bookingData = RuanganBooking::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json(['bookingData' => $bookingData], 200);
    }
    public function bookRoom(Request $request)
{
    // Validasi input form booking ruangan
    $validator = Validator::make($request->all(), [
        'room_id' => 'required|exists:ruangan,id',
        'reason' => 'required',
        'start_time' => 'required|date|after:now',
        'end_time' => 'required|date|after:start_time',
    ]);

    if ($validator->fails()) {
        return response()->json(['error' => $validator->errors()], 422);
    }

    // Cek apakah ruangan tersedia pada waktu yang diminta
    if ($this->isRoomAvailable($request->input('room_id'), $request->input('start_time'), $request->input('end_time'))) {
        // Buat booking ruangan baru
        RuanganBooking::create([
            'user_id' => Auth::id(),
            'room_id' => $request->input('room_id'),
            'reason' => $request->input('reason'),
            'start_time' => $request->input('start_time'),
            'end_time' => $request->input('end_time'),
            // Tambahkan field lain sesuai kebutuhan
        ]);

        return response()->json(['message' => 'Booking ruangan berhasil!'], 200);
    } else {
        return response()->json(['error' => 'Ruangan telah di-booking pada waktu tersebut.'], 422);
    }
}

    // Method untuk mengecek ketersediaan ruangan pada waktu tertentu
    private function isRoomAvailable($roomId, $startTime, $endTime)
    {
        $existingBookings = RuanganBooking::where('room_id', $roomId)
            ->where(function ($query) use ($startTime, $endTime) {
                $query->whereBetween('start_time', [$startTime, $endTime])
                    ->orWhereBetween('end_time', [$startTime, $endTime]);
            })
            ->count();

        return $existingBookings === 0;
    }

    public function destroy($id)
{
    $RequestBookingRuangan = RuanganBooking::find($id);

    if (!$RequestBookingRuangan) {
        return response([
            'message' => 'Request Izin Bermalam Tidak Ditemukan',
        ], 403);
    }

    if ($RequestBookingRuangan->user_id != auth()->user()->id) {
        return response([
            'message' => 'Akun Anda Tidak memiliki Akses',
        ], 403);
    }

    $RequestBookingRuangan->delete();

    return response([
        'message' => 'Request Izin Bermalam Telah Dihapus',
    ], 200);
}

}
