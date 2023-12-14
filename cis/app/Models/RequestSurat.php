<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestSurat extends Model
{
    use HasFactory;
    protected $table ="request_surat";
    protected $fillable = ['user_id', 'reason', 'start_date', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
