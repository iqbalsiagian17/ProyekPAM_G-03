<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RuanganBooking extends Model
{
    use HasFactory;
    protected $table = 'ruangan_booking';

    protected $fillable = [
        'user_id',
        'ruangan',
        'room_id',
        'start_time',
        'end_time',
    ];

    // Relasi dengan model User
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Relasi dengan model Ruangan
}
