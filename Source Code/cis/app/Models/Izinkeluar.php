<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Izinkeluar extends Model
{
    use HasFactory;
    protected $table="izinkeluar";

    protected $fillable = [
        'user_id',
        'approve_id',
        'reason',
        'status',
        'time_out',
        'time_in'
    ];

    // Relasi ke model User untuk user_id
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    // Relasi ke model User untuk approve_id
    public function approver()
    {
        return $this->belongsTo(User::class, 'approve_id');
    }
}
