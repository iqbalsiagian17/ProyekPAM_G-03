<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RuanganBooking; 
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class BookingRuanganController extends Controller
{
    /**
     * Display a listing of the resource.
     */
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
        'message' => 'Request Izin Keluar dibuat',
        'RuanganBooking'=>$user
    ], 200);
}


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        return response([
            'RuanganBooking' => RuanganBooking::where('id', $id)->get()
        ], 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Request $request, string $id)
    {
          }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $BookingRuangan = RuanganBooking::find($id);
    if (!$BookingRuangan) {
        return response([
            'message' => 'Request Izin Keluar Tidak Ditemukan',
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
        'message' => 'Request Izin Keluar Telah Diupdate',
        'RequestIzinKeluar' => $BookingRuangan
    ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $BookingRuangan = RuanganBooking::find($id);

        if (!$BookingRuangan) {
            return response([
                'message' => 'Request Izin Keluar Tidak Ditemukan',
            ], 403);
        }
    
        if ($BookingRuangan->user_id != auth()->user()->id) {
            return response([
                'message' => 'Akun Anda Tidak memiliki Akses',
            ], 403);
        }
    
        $BookingRuangan->delete();
    
        return response([
            'message' => 'Request Izin Keluar Telah Dihapus',
        ], 200);
    }
}
