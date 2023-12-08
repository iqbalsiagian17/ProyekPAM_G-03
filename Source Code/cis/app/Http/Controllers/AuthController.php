<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // Register a new user
    public function register(Request $request)
    {
        // Validate input data
        $rules = [
            'nim' => 'required|string',
            'nama' => 'required|string',
            'noKtp' => 'required|string|unique:users',
            'nomorHandphone' => 'required|string',
            'email' => 'required|string|unique:users',
            'password' => 'required|string|min:6'
        ];
        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        // Create a new user in the users table
        $user = User::create([
            'nim' => $request->nim,
            'noKtp' => $request->noKtp,
            'nama' => $request->nama,
            'nomorHandphone' => $request->nomorHandphone,
            'email' => $request->email,
            'password' => Hash::make($request->password)
        ]);

        $token = $user->createToken('Personal Access Token')->plainTextToken;
        $response = ['user' => $user, 'token' => $token];

        return response()->json($response, 200);
    }

    // Login existing user
    public function login(Request $request)
    {
        // Validate input data
        $rules = [
            'email' => 'required',
            'password' => 'required|string'
        ];
        $request->validate($rules);

        // Find user by email in the users table
        $user = User::where('email', $request->email)->first();

        // Check if user email found and password is correct
        if ($user && Hash::check($request->password, $user->password)) {
            $token = $user->createToken('Personal Access Token')->plainTextToken;
            $response = ['user' => $user, 'token' => $token];

            return response()->json($response, 200);
        }

        $response = ['message' => 'Incorrect email or password'];
        return response()->json($response, 400);
    }

    public function getAllUsers()
    {
        $users = User::all();
    
        if ($users->isEmpty()) {
            $response = ['message' => 'No users found'];
            return response()->json($response, 404);
        }
    
        return response()->json($users, 200);
    }
}
