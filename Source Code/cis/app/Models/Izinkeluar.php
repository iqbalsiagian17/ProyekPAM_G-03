<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Izinkeluar extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'reason',
        'status',
        'time_out',
        'time_in',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}