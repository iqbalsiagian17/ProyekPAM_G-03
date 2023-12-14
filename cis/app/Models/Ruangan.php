<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ruangan extends Model
{
    use HasFactory;
    protected $table = 'ruangan';

    protected $fillable = [
        'nama_ruangan',
    ];


    public function bookings()
    {
        return $this->hasMany(RuanganBooking::class, 'room_id');
    }
}
