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
        $user = Auth::user();

        $ruanganBookingData = RuanganBooking::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();
    
        return response([
            'RuanganBooking' => $ruanganBookingData
        ], 200);
    }
    public function store(Request $request)
{
    $rules = [
        'ruangan' => 'required|string',
        'start_time' => 'required',
        'end_time' =>'required',
    ];

    $validator = Validator::make($request->all(), $rules);
    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
  
    $existingBooking = RuanganBooking::where('ruangan', $request->input('ruangan'))
    ->where(function ($query) use ($request) {
        $query->where(function ($q) use ($request) {
            $q->where('start_time', '>=', $request->input('start_time'))
                ->where('start_time', '<', $request->input('end_time'));
        })->orWhere(function ($q) use ($request) {
            $q->where('end_time', '>', $request->input('start_time'))
                ->where('end_time', '<=', $request->input('end_time'));
        });
    })
    ->exists();

if ($existingBooking) {
    return response()->json(['message' => 'Ruangan telah dipesan pada rentang waktu tersebut'], 400);
}

    $user = RuanganBooking::create([
        'ruangan' => $request->input('ruangan'),
        'start_time' => $request->input('start_time'),
        'end_time' => $request->input('end_time'),
        'user_id' => auth()->user()->id
    ]);

    return response([
        'message' => 'Booking Ruangan dibuat',
        'RuanganBooking'=>$user
    ], 200);
}

    public function show(string $id)
    {
        return response([
            'RuanganBooking' => RuanganBooking::where('id', $id)->get()
        ], 200);
    }

    public function update(Request $request, string $id)
    {
        $BookingRuangan = RuanganBooking::find($id);
    if (!$BookingRuangan) {
        return response([
            'message' => 'Booking Ruangan Tidak Ditemukan',
        ], 403);
    }
    if ($BookingRuangan->user_id != auth()->user()->id) {
        return response([
            'message' => 'Akun Anda Tidak mengakses Ini',
        ], 403);
    }

    $validator = Validator::make($request->all(), [
        'ruangan' => 'required|string', 
        'start_time' => 'required|date',
        'end_time' => 'required|date',
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }

    $BookingRuangan->update([
        'ruangan' => $request->input('ruangan'),
        'start_time' => $request->input('start_time'),
        'end_time' => $request->input('end_time'),
    ]);

    return response([
        'message' => 'Booking Ruangan Telah Diupdate',
        'RequestIzinKeluar' => $BookingRuangan
    ], 200);
    }

    public function destroy(string $id)
    {
        $BookingRuangan = RuanganBooking::find($id);

        if (!$BookingRuangan) {
            return response([
                'message' => 'Booking Ruangan Tidak Ditemukan',
            ], 403);
        }
    
        if ($BookingRuangan->user_id != auth()->user()->id) {
            return response([
                'message' => 'Akun Anda Tidak memiliki Akses',
            ], 403);
        }
    
        $BookingRuangan->delete();
    
        return response([
            'message' => 'Booking Ruangan Telah Dihapus',
        ], 200);
    }

    public function viewAllRequestsForBaak()
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Mengambil semua data RequestIzinKeluar
    $ruanganBookingData = RuanganBooking::orderBy('created_at', 'desc')->get();

    return response([
        'RuanganBooking' => $ruanganBookingData
    ], 200);
}

public function approveBookingRuangan($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan Booking Ruangan berdasarkan ID
    $BookingRuangan = RuanganBooking::find($id);

    if (!$BookingRuangan) {
        return response()->json(['message' => 'Booking Ruangan Tidak Ditemukan'], 404);
    }

    // Update status permintaan Booking Ruangan menjadi 'approved'
    $BookingRuangan->status = 'approved';
    $BookingRuangan->save();

    return response()->json(['message' => 'Permintaan Booking Ruangan Telah Disetujui'], 200);
}

public function rejectBookingRuangan($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan Booking Ruangan berdasarkan ID
    $BookingRuangan = RuanganBooking::find($id);

    if (!$BookingRuangan) {
        return response()->json(['message' => 'Booking Ruangan Tidak Ditemukan'], 404);
    }

    // Update status permintaan Booking Ruangan menjadi 'rejected'
    $BookingRuangan->status = 'rejected';
    $BookingRuangan->save();

    return response()->json(['message' => 'Permintaan Booking Ruangan Telah Ditolak'], 200);
}
}
