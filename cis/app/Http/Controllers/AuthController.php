<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;


class AuthController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function register(Request $req)
    {
        //valdiate
        $rules = [
            'name' => 'required|string',
            'email' => 'required|string|unique:users',
            'nomor_ktp' =>'required|string|unique:users',
            'nim' =>'required|string|unique:users',
            'nomor_handphone'=>'required|string|unique:users',
            'password' => 'required|string|min:6',
        ];
        $validator = Validator::make($req->all(), $rules);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        
        //create new user in users table
        $user = User::create([
            'name' => $req->name,
            'email' => $req->email,
            'nomor_ktp' => $req->nomor_ktp,
            'nim' => $req->nim,
            'nomor_handphone' => $req->nomor_handphone,
            'password' => Hash::make($req->password)
        ]);
        $token = $user->createToken('Personal Access Token')->plainTextToken;
        $response = ['user' => $user, 'token' => $token];
        return response()->json($response, 200);
    }
    

    /**
     * Show the form for creating a new resource.
     */
    public function login(Request $req)
{
    // Validate inputs
    $rules = $req->validate([
        'email' => 'required|email',
        'password' => 'required|string'
    ]);

    if (!Auth::attempt($rules)) {
        return response(['message' => 'Invalid credentials'], 403);
    }

    $token = $req->user()->createToken('Auth Token')->plainTextToken;

    return response([
        'user' => $req->user(),
        'token' => $token
    ], 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function user(){
        return response([
            'user' => auth()->user()
        ],200);
    }

    /**
     * Display the specified resource.
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
    
        return response([
            'message' => 'Logout Success'
        ], 200);
    }
    
}
