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
            'pickup_time' => 'required',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
      
        $user = RequestSurat::create([
            'reason' => $request->input('reason'),
            'pickup_time' => $request->input('pickup_time'),
            'user_id' => auth()->user()->id
        ]);
        return response([
            'message' => 'Request Surat dibuat',
            'RequestIzinKeluar'=>$user
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
        'pickup_time' => 'required|date',
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
       $RequestSurat->update([
         'reason' => $request->input('reason'),
        'pickup_time' => $request->input('pickup_time'),
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
}
