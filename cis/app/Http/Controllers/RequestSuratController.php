<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RequestSurat; 
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class RequestSuratController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = Auth::user();

        $requestSuratData = RequestSurat::where('user_id', $user->id)
        ->orderBy('created_at', 'desc')
        ->get();

    return response([
        'RequestSurat' => $requestSuratData
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
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
      
        $user = RequestSurat::create([
            'reason' => $request->input('reason'),
            'start_date' => $request->input('start_date'),
            'user_id' => auth()->user()->id
        ]);
        return response([
            'message' => 'Request Surat dibuat',
            'RequestSurat'=>$user
        ], 200);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        return response([
            'RequestSurat' => RequestSurat::where('id', $id)->get()
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
        $RequestSurat= RequestSurat::find($id);
       if(!$RequestSurat){
        return response([
            'message' => 'Request Surat Tidak Ditemukan',
        ], 403);
       }
       if($RequestSurat->user_id !=auth()->user()->id){
        return response([
            'message' => 'Akun Anda Tidak mengakses Ini',
        ], 403);
       }
       $validator = Validator::make($request->all(), [
        'reason' => 'required|string',
        'start_date' => 'required|date',
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
       $RequestSurat->update([
         'reason' => $request->input('reason'),
        'start_date' => $request->input('start_date'),
    ]);
    return response([
        'message' => 'Request Surat Telah Diupdate',
        'RequestSurat'=>$RequestSurat
    ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
{
    $RequestSurat = RequestSurat::find($id);

    if (!$RequestSurat) {
        return response([
            'message' => 'Request Surat Tidak Ditemukan',
        ], 403);
    }

    if ($RequestSurat->user_id != auth()->user()->id) {
        return response([
            'message' => 'Akun Anda Tidak memiliki Akses',
        ], 403);
    }

    $RequestSurat->delete();

    return response([
        'message' => 'Request Surat Telah Dihapus',
    ], 200);
}


public function viewAllRequestsForBaak()
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Mengambil semua data RequestIzinKeluar
    $requestSuratData = RequestSurat::orderBy('created_at', 'desc')->get();

    
    return response([
        'RequestSurat' => $requestSuratData
    ], 200);
}

public function approveRequestSurat($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $requestKeluar = RequestSurat::find($id);

    if (!$requestKeluar) {
        return response()->json(['message' => 'Request Surat Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'approved'
    $requestKeluar->status = 'approved';
    $requestKeluar->save();

    return response()->json(['message' => 'Permintaan Request Surat Telah Disetujui'], 200);
}

public function rejectRequestSurat($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $requestSurat = RequestSurat::find($id);

    if (!$requestSurat) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'rejected'
    $requestSurat->status = 'rejected';
    $requestSurat->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Ditolak'], 200);
}


}
