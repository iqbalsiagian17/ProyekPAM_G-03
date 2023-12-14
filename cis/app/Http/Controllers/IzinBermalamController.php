<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use App\Models\IzinBermalam; 
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;

class IzinBermalamController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = Auth::user();

        $izinKeluarData = IzinBermalam::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();
    
        return response([
            'RequestIzinBermalam' => $izinKeluarData
        ], 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create($id)
    {
        return response([
            'RequestIzinBermalam' => IzinBermalam::where('id', $id)->get()
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $rules = [
            'reason' => 'required|string',
            'start_date' => 'required|date_format:Y-m-d H:i:s',
            'end_date' => 'required|date_format:Y-m-d H:i:s',
        ];
    
        $validator = Validator::make($request->all(), $rules);
    
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
    
        $startDateTime = new \DateTime($request->input('start_date'));
        $endDateTime = new \DateTime($request->input('end_date'));
    
        // Check if the request is made on Friday after 17:00 or on Saturday between 08:00 and 17:00
        if (!($startDateTime->format('N') == 5 && $startDateTime->format('H') >= 17) &&
            !($startDateTime->format('N') == 6 && $startDateTime->format('H') >= 8 && $startDateTime->format('H') < 17) &&
            !($endDateTime->format('N') == 6 && $endDateTime->format('H') < 17)) {
            return response()->json(['message' => 'Izin bermalam hanya bisa direquest pada Jumat setelah pukul 17:00 dan Sabtu antara pukul 08:00 - 17:00.'], 403);
        }
    
        $user = IzinBermalam::create([
            'reason' => $request->input('reason'),
            'start_date' => $startDateTime,
            'end_date' => $endDateTime,
            'user_id' => auth()->user()->id,
        ]);
    
        return response([
            'message' => 'Request Izin Keluar dibuat',
            'RequestIzinBermalam' => $user
        ], 200);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
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
    public function update(Request $request, string $id)
    {
        $requestIzinBermalam = IzinBermalam::find($id);

    if (!$requestIzinBermalam) {
        return response([
            'message' => 'Request Izin Keluar Tidak Ditemukan',
        ], 403);
    }

    if ($requestIzinBermalam->user_id != auth()->user()->id) {
        return response([
            'message' => 'Akun Anda Tidak mengakses Ini',
        ], 403);
    }

    $validator = Validator::make($request->all(), [
        'reason' => 'required|string',
        'start_date' => 'required|date_format:Y-m-d H:i:s',
        'end_date' => 'required|date_format:Y-m-d H:i:s',
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }

    $startDateTime = new \DateTime($request->input('start_date'));
    $endDateTime = new \DateTime($request->input('end_date'));

    // Check if the request is made on Friday after 17:00 or on Saturday between 08:00 and 17:00
    if (!($startDateTime->format('N') == 5 && $startDateTime->format('H') >= 17) &&
        !($startDateTime->format('N') == 6 && $startDateTime->format('H') >= 8 && $startDateTime->format('H') < 17) &&
        !($endDateTime->format('N') == 6 && $endDateTime->format('H') < 17)) {
        return response()->json(['message' => 'Izin bermalam hanya bisa direquest pada Jumat setelah pukul 17:00 dan Sabtu antara pukul 08:00 - 17:00.'], 403);
    }

    $requestIzinBermalam->update([
        'reason' => $request->input('reason'),
        'start_date' => $startDateTime,
        'end_date' => $endDateTime,
    ]);

    return response([
        'message' => 'Request Izin Bermalam Telah Diupdate',
        'RequestIzinBermalam' => $requestIzinBermalam
    ], 200);
    }

    
    public function destroy($id)
{
    $RequestIzinBermalam = IzinBermalam::find($id);

    if (!$RequestIzinBermalam) {
        return response([
            'message' => 'Request Izin Bermalam Tidak Ditemukan',
        ], 403);
    }

    if ($RequestIzinBermalam->user_id != auth()->user()->id) {
        return response([
            'message' => 'Akun Anda Tidak memiliki Akses',
        ], 403);
    }

    $RequestIzinBermalam->delete();

    return response([
        'message' => 'Request Izin Bermalam Telah Dihapus',
    ], 200);
}

public function viewAllRequestsForBaak()
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Mengambil semua data RequestIzinKeluar
    $izinBermalamData = IzinBermalam::orderBy('created_at', 'desc')->get();

    return response([
        'RequestIzinBermalam' => $izinBermalamData
    ], 200);
}

public function approveIzinBermalam($id)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $izinBermalam = IzinBermalam::find($id);

    if (!$izinBermalam) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'approved'
    $izinBermalam->status = 'approved';
    $izinBermalam->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Disetujui'], 200);
}

public function rejectizinBermalam($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $izinBermalam = IzinBermalam::find($id);

    if (!$izinBermalam) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'rejected'
    $izinBermalam->status = 'rejected';
    $izinBermalam->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Ditolak'], 200);
}

    }

