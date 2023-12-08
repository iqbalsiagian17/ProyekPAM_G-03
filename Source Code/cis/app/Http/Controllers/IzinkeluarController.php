<?php

namespace App\Http\Controllers;

use App\Models\Izinkeluar;
use Illuminate\Http\Request;

class IzinkeluarController extends Controller
{
    public function requestPermission(Request $request)
    {
        // Logika untuk Mahasiswa membuat permintaan izin keluar
        $permission = Izinkeluar::create([
            'user_id' => $request->user()->id,
            'reason' => $request->reason,
            'status' => 'pending', 
            'time_out' => $request->time_out,
            'time_in' => $request->time_in,
        ]);

        return response()->json($permission, 201);
    }

    public function approvePermission(Request $request, Izinkeluar $izinkeluar)
    {
        // Pastikan hanya 'baak' yang dapat menyetujui izin
        if ($request->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        // Logika untuk menyetujui izin keluar oleh 'baak'
        $izinkeluar->update(['status' => 'approved']);

        return response()->json($izinkeluar, 200);
    }

    public function rejectPermission(Request $request, Izinkeluar $izinkeluar)
    {
        // Pastikan hanya 'baak' yang dapat menolak izin
        if ($request->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        // Logika untuk menolak izin keluar oleh 'baak'
        $izinkeluar->update(['status' => 'rejected']);

        return response()->json($izinkeluar, 200);
    }
}
