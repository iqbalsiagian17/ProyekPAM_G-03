<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\IzinKeluar; 
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use App\Models\Ruangan;


class IzinKeluarController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Mendapatkan pengguna yang sedang login
        $user = Auth::user();
    
        // Mengambil data RequestIzinKeluar sesuai dengan user yang login
        $izinKeluarData = IzinKeluar::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();
    
        return response([
            'RequestIzinKeluar' => $izinKeluarData
        ], 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $rules = [
            'reason' => 'required|string',
            'start_date' => 'required',
            'end_date' =>'required',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
      
        $user = IzinKeluar::create([
            'reason' => $request->input('reason'),
            'start_date' => $request->input('start_date'),
            'end_date' => $request->input('end_date'),
            'user_id' => auth()->user()->id
        ]);
        return response([
            'message' => 'Request Izin Keluar dibuat',
            'RequestIzinKeluar'=>$user
        ], 200);
    }




    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        return response([
            'RequestIzinKeluar' => IzinKeluar::where('id', $id)->get()
        ], 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request,$id)
    {
        $RequestIzinKeluar= IzinKeluar::find($id);
       if(!$RequestIzinKeluar){
        return response([
            'message' => 'Request Izin Keluar Tidak Ditemukan',
        ], 403);
       }
       if($RequestIzinKeluar->user_id !=auth()->user()->id){
        return response([
            'message' => 'Akun Anda Tidak mengakses Ini',
        ], 403);
       }
       $validator = Validator::make($request->all(), [
        'reason' => 'required|string',
        'start_date' => 'required|date',
        'end_date' => 'required|date',
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
       $RequestIzinKeluar->update([
         'reason' => $request->input('reason'),
        'start_date' => $request->input('start_date'),
        'end_date' => $request->input('end_date'),
    ]);
    return response([
        'message' => 'Request Izin Keluar Telah Diupdate',
        'RequestIzinKeluar'=>$RequestIzinKeluar
    ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
    $RequestIzinKeluar = IzinKeluar::find($id);

    if (!$RequestIzinKeluar) {
        return response([
            'message' => 'Request Izin Keluar Tidak Ditemukan',
        ], 403);
    }

    if ($RequestIzinKeluar->user_id != auth()->user()->id) {
        return response([
            'message' => 'Akun Anda Tidak memiliki Akses',
        ], 403);
    }

    $RequestIzinKeluar->delete();

    return response([
        'message' => 'Request Izin Keluar Telah Dihapus',
    ], 200);
}

public function viewAllRequestsForBaak()
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Mengambil semua data RequestIzinKeluar
    $izinKeluarData = IzinKeluar::orderBy('created_at', 'desc')->get();

    return response([
        'RequestIzinKeluar' => $izinKeluarData
    ], 200);
}

public function approveIzinKeluar($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $izinKeluar = IzinKeluar::find($id);

    if (!$izinKeluar) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'approved'
    $izinKeluar->status = 'approved';
    $izinKeluar->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Disetujui'], 200);
}

public function rejectIzinKeluar($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $izinKeluar = IzinKeluar::find($id);

    if (!$izinKeluar) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'rejected'
    $izinKeluar->status = 'rejected';
    $izinKeluar->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Ditolak'], 200);
}



public function getMahasiswa()
{
    $mhs = User::all();

    return response()->json($mhs, 200);
}

public function getRuangan()
{
    $rng = Ruangan::all();

    return response()->json($rng, 200);
}

}
