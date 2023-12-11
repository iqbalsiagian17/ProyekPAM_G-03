<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Izinkeluar;
use App\Models\User;

class IzinkeluarController extends Controller
{
    public function requestIzinKeluar(Request $request)
    {
        // Validasi input, misalnya pastikan alasan tidak kosong
        $request->validate([
            'reason' => 'required',
            'time_out' => 'required|date',
            'time_in' => 'required|date'
        ]);

        // Buat izin keluar baru untuk role 'mahasiswa'
        $izinKeluar = Izinkeluar::create([
            'user_id' => auth()->user()->id, // ID pengguna yang membuat permintaan (role 'mahasiswa')
            'reason' => $request->input('reason'),
            'status' => 'pending', // Secara default status adalah 'pending'
            'time_out' => $request->input('time_out'),
            'time_in' => $request->input('time_in'),
        ]);

        return response()->json(['message' => 'Izin keluar berhasil diajukan']);
    }

    


    public function getAllIzinKeluar(Request $request)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinKeluarList = Izinkeluar::with('user')->get();

    return response()->json($izinKeluarList);
}


    public function approveIzinKeluar(Request $request, $izinId)
    {
        // Validasi peran 'baak'
        if (auth()->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        // Cari izin keluar berdasarkan ID
        $izinKeluar = Izinkeluar::findOrFail($izinId);

        // Setujui izin keluar
        $izinKeluar->approve_id = auth()->user()->id; // ID pengguna yang menyetujui (role 'baak')
        $izinKeluar->status = 'approved';
        $izinKeluar->save();

        return response()->json(['message' => 'Izin keluar berhasil disetujui']);
    }
}
